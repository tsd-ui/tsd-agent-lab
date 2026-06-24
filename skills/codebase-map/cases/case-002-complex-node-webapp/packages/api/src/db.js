const { Pool } = require('pg');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL || 'postgres://taskflow:taskflow@localhost:5432/taskflow',
});

async function query(text, params) {
  const start = Date.now();
  const result = await pool.query(text, params);
  const duration = Date.now() - start;
  if (duration > 500) console.warn(`Slow query (${duration}ms):`, text);
  return result;
}

module.exports = { pool, query };
