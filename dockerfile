FROM node:16
COPY . .
RUN npm install --no-fund -g npm@9.7.2
RUN npm install --no-fund express
CMD ["npm", "start"]
