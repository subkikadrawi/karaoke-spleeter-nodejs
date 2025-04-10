import express from 'express';
import fs from 'fs';
// import path from 'path';

const app = express();

app.get('/indo/:title_music', (req, res) => {
  //   const videoPath = path.join(__dirname, req.body.pathUrl);
  const titleMusic = req.params.title_music;
  const videoPath = `./indo/${titleMusic}`;

  try {
    const stat = fs.statSync(videoPath);
    const fileSize = stat.size;
    const range = req.headers.range;

    if (range) {
      const parts = range.replace(/bytes=/, "").split("-");
      const start = parseInt(parts[0], 10);
      const end = parts[1] ? parseInt(parts[1], 10) : fileSize - 1;
      const chunkSize = end - start + 1;
      const file = fs.createReadStream(videoPath, { start, end });

      res.writeHead(206, {
        "Content-Range": `bytes ${start}-${end}/${fileSize}`,
        "Accept-Ranges": "bytes",
        "Content-Length": chunkSize,
        "Content-Type": "video/mp4",
      });

      file.pipe(res);
    } else {
      res.writeHead(200, {
        "Content-Length": fileSize,
        "Content-Type": "video/mp4",
      });
      fs.createReadStream(videoPath).pipe(res);
    }
  } catch (err) {
    res.status(404).send('File not found');
  }
});

app.get('/indo/separated/:title_music/:type_file', (req, res) => {
  //   const videoPath = path.join(__dirname, req.body.pathUrl);
  const titleMusic = req.params.title_music;
  const typeFile = req.params.type_file;
  const videoPath = `./indo/separated/${titleMusic}/${typeFile}`;
  console.log(videoPath);

  try {
    const stat = fs.statSync(videoPath);
    const fileSize = stat.size;
    const range = req.headers.range;

    if (range) {
      const parts = range.replace(/bytes=/, "").split("-");
      const start = parseInt(parts[0], 10);
      const end = parts[1] ? parseInt(parts[1], 10) : fileSize - 1;
      const chunkSize = end - start + 1;
      const file = fs.createReadStream(videoPath, { start, end });

      res.writeHead(206, {
        "Content-Range": `bytes ${start}-${end}/${fileSize}`,
        "Accept-Ranges": "bytes",
        "Content-Length": chunkSize,
        "Content-Type": "audio/mpeg",
      });

      file.pipe(res);
    } else {
      res.writeHead(200, {
        "Content-Length": fileSize,
        "Content-Type": "audio/mpeg",
      });
      fs.createReadStream(videoPath).pipe(res);
    }
  } catch (err) {
    res.status(404).send('File not found');
  }
});

app.listen(5500, () => console.log('Server running on port 5500'));
