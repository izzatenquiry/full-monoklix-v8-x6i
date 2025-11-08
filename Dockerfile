# =======================================================
# 🔨 Build Stage
# =======================================================
FROM node:20-bullseye-slim AS build

# Set working directory
WORKDIR /app

# Copy package files terlebih dahulu (supaya Docker cache berfungsi)
COPY package*.json ./

# Pastikan semua dependencies termasuk dev dipasang
RUN npm install --include=dev

# Copy semua source code
COPY . .

# Build React (Vite)
RUN npm run build


# =======================================================
# 🚀 Production Stage
# =======================================================
FROM node:20-bullseye-slim

# Buat directory kerja baru
WORKDIR /app

# Install `serve` untuk host SPA (single-page app)
RUN npm install -g serve

# Copy hasil build dari stage pertama
COPY --from=build /app/dist ./dist

# Dedahkan port
EXPOSE 8080

# Jalankan aplikasi
CMD ["serve", "-s", "dist", "-l", "8080"]
