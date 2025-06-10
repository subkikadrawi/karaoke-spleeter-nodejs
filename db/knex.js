import knex from 'knex';

const db = knex({
  client: 'mysql2',
  connection: {
    host: 'localhost',
    port: 3316,
    user: 'karaokeBilling',
    password: 'karaokeBilling',
    database: 'forge'
  }
});

export default db;