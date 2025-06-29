import 'dotenv/config'; // Add this line at the very top
import express from 'express';
import fs from 'fs';
// import path from 'path';
import cors from 'cors'; // Add this line
import db from './db/knex.js';
import { S3Client, GetObjectCommand } from "@aws-sdk/client-s3";
import { getSignedUrl } from "@aws-sdk/s3-request-presigner";


const app = express();

const s3 = new S3Client({
  region: "us-east-1", // or your preferred region
  endpoint: "https://nos.wjv-1.neo.id", // custom S3-compatible endpoint
  forcePathStyle: true, // often required for S3-compatible storage
  credentials: {
    accessKeyId: process.env.AWS_ACCESS_KEY_ID, // set in your env
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY, // set in your env
  },
});

// Define your whitelist
const whitelist = [
  'http://localhost:3000',
  'http://localhost:5173',
  'http://103.127.138.140:5173',
  // Add more domains as needed
];

const corsOptions = {
  origin: function (origin, callback) {
    // Allow requests with no origin (like mobile apps, curl, etc.)
    if (!origin || whitelist.indexOf(origin) !== -1) {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  }
};

app.use(cors(corsOptions)); // Use CORS with options

app.get('/musics/indo', async (req, res) => {

  const {title='',size='20', page='1'} = req.query;
  const offset = (page - 1) * size; // Calculate offset for pagination

  // Example: select all from music_tbl
  const lsMusic = await db('music_tbl')
                        .select('*')
                        .where('title', 'like', `%${title.toLowerCase()}%`)
                        .orderBy('id', 'asc')
                        .offset(offset)
                        .limit( size === '' ? 20 : size );

  try {
    res.status(200).json({
      data: lsMusic
    });
  } catch (error) {
    res.status(501).send(error);
  }

})

app.get('/musics/indo/:title_music', async (req, res) => {
  const titleMusic = req.params.title_music;
  const key = `musics/indo/${titleMusic}`; // S3 object key
  const range = req.headers.range;

  try {
    const commandParams = {
      Bucket: "karaoke-reactjs", // replace with your bucket
      Key: key,
    };
    if (range) {
      commandParams.Range = range; // e.g. "bytes=0-"
    }

    const command = new GetObjectCommand(commandParams);
    const s3Response = await s3.send(command);
    console.log(s3Response);

    // Set headers for partial or full content
    if (range && s3Response.ContentRange) {
      res.status(206);
      res.set({
        'Content-Range': s3Response.ContentRange,
        'Accept-Ranges': 'bytes',
        'Content-Length': s3Response.ContentLength,
        'Content-Type': s3Response.ContentType || 'video/mp4',
      });
    } else {
      res.set({
        'Content-Length': s3Response.ContentLength,
        'Content-Type': s3Response.ContentType || 'video/mp4',
      });
    }

    // Stream S3 data to client
    s3Response.Body.pipe(res);
  } catch (err) {
    res.status(404).send('File not found');
  }
});

app.get('/musics/indo/separated/:title_music/:type_file', async (req, res) => {
  const titleMusic = req.params.title_music;
  const typeFile = req.params.type_file;
  const key = `musics/indo/separated/${titleMusic}/${typeFile}`; // S3 object key
  const range = req.headers.range;

  try {
    const commandParams = {
      Bucket: "karaoke-reactjs", // replace with your bucket
      Key: key,
    };
    if (range) {
      commandParams.Range = range; // e.g. "bytes=0-"
    }

    const command = new GetObjectCommand(commandParams);
    const s3Response = await s3.send(command);

    // Set headers for partial or full content
    if (range && s3Response.ContentRange) {
      res.status(206);
      res.set({
        'Content-Range': s3Response.ContentRange,
        'Accept-Ranges': 'bytes',
        'Content-Length': s3Response.ContentLength,
        'Content-Type': s3Response.ContentType || 'audio/mpeg',
      });
    } else {
      res.set({
        'Content-Length': s3Response.ContentLength,
        'Content-Type': s3Response.ContentType || 'audio/mpeg',
      });
    }

    // Stream S3 data to client
    s3Response.Body.pipe(res);
  } catch (err) {
    res.status(404).send('File not found');
  }
});

// Check DB connection before starting server
db.raw('SELECT 1')
  .then(() => {
    console.log('Database connected!');
    app.listen(5500, () => console.log('Server running on port 5500'));
  })
  .catch((err) => {
    console.error('Database connection failed:', err);
    process.exit(1); // Exit if DB is not connected
  });