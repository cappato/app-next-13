FROM node:16.8.0-alpine AS builder

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --production

COPY . .

RUN yarn build

FROM node:16.8.0-alpine

WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules

COPY --from=builder /app/package.json /app/next.config.js /app/next-env.d.ts ./

COPY --from=builder /app/public ./public

COPY --from=builder /app/.next ./.next

EXPOSE 3000

CMD ["yarn", "start"]

