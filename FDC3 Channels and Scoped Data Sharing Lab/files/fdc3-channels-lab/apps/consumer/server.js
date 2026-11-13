const express = require('express');
const path = require('path');
const app = express();
const root = path.resolve(__dirname, '../../');
app.use('/shared', express.static(path.join(root, 'shared')));
app.use(express.static(__dirname));
app.listen(3002, '0.0.0.0', () => console.log('Consumer app on port 3002'));
