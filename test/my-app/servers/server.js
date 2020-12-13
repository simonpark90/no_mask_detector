
const express = require('express');
const app = express();
//const cors = require('cors');
const bodyParser = require('body-parser');
const port =process.env.PORT || 3001;
const mysql = require('mysql');
//app.use(cors());

let dbconfig = require(__dirname+'/../servers/config/db-config.json');
let connection = mysql.createConnection(dbconfig);

app.use(bodyParser.json());
app.use('/api', (req, res)=> res.json({username:'bryan'}));

/*
 * DB -> Server 데이터 잘 불러오는지 테스트
 * www.mask-detector.ml/list
*/
app.get('/list', (req, res) =>{
	connection.query("SELECT * FROM ADMIN", (err, rows) => {
		if(err) throw err;

		res.send(rows);
	});
});

app.listen(port, ()=>{
    console.log(`express is running on ${port}`);
})
