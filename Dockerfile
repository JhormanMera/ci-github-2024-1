# Use a base image with the latest Node.js LTS installed
FROM node:20

# Set the working directory inside the container
WORKDIR /app

# Copy the application code to the working directory
COPY . .

# Install dependencies
RUN npm install


# Build the app
RUN npm run build

EXPOSE 3000

# Start the app
CMD ["npm", "start"]
