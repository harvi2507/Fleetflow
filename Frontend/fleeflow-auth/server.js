// server.js
import express from 'express'
import cors from 'cors'
import dotenv from 'dotenv'
import authRoutes from './routes/auth.js'

dotenv.config()

const app = express()
const PORT = process.env.PORT || 5000

// ── Middleware ──────────────────────────────────────────────
app.use(cors({
  origin: process.env.CLIENT_URL || 'http://127.0.0.1:5500',  // VS Code Live Server default
  credentials: true
}))
app.use(express.json())

// ── Routes ──────────────────────────────────────────────────
app.use('/api/auth', authRoutes)

// ── Health check ────────────────────────────────────────────
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', message: 'FleetFlow Auth API running' })
})

// ── 404 ─────────────────────────────────────────────────────
app.use((req, res) => {
  res.status(404).json({ error: 'Route not found' })
})

// ── Start ───────────────────────────────────────────────────
app.listen(PORT, () => {
  console.log(`
  ┌──────────────────────────────────────────┐
  │  FleetFlow Auth API → http://localhost:${PORT} │
  └──────────────────────────────────────────┘
  `)
})
