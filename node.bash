curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source ~/.bashrc
nvm install --lts
npm install pm2 -g
npm -v
nvm -v
node -v
pm2 -v