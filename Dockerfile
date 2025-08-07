# Use the official AWS Lambda Node.js 18 base image
FROM public.ecr.aws/lambda/nodejs:18

# Copy package files first for better layer caching
COPY package*.json ./

# Install all dependencies (including dev dependencies for build)
RUN npm ci

# Copy TypeScript source files and config
COPY src/ ./src/
COPY tsconfig.json ./

# Build TypeScript to JavaScript
RUN npm run build

# Copy the built files to the Lambda task root
RUN cp -r dist/* ${LAMBDA_TASK_ROOT}/

# Clean up dev dependencies to reduce image size
RUN npm prune --production

# Set the CMD to your handler (matching the export name)
CMD [ "index.lambdaHandler" ]