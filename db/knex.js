import knex from 'knex';

const db = knex({
  client: 'mysql2',
  connection: {
    host: '103.127.138.140',
    port: 3316,
    user: 'karaokeBilling',
    password: 'karaokeBilling',
    database: 'forge'
  }
});

export default db;