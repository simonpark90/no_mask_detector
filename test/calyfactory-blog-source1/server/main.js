import express from 'express';
import bodyParser from 'body-parser';
import mysql from 'mysql';
import path from 'path';


let dbconfig = require(__dirname+'/../server/config/db-config.json');
let connection = mysql.createConnection(dbconfig);

const app = express();
const port = process.env.PORT || 3000;

app.use('/', express.static(__dirname + "/../public"));
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use('/api', (req, res) => res.json({username:'bryan'}));

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

/* 
 * Server -> DB 데이터 저장 되는지 테스트
 * PostMan 테스트
 * 	- Body -> x-www-form-urlencoded -> id, pw
 * 	- www.mask-detector.ml/insert
*/
app.post('/insert', function (req, res) {
    var adminId = req.body.id
    var adminPw = req.body.pw

    connection.query("INSERT INTO ADMIN (ADMIN_ID, ADMIN_PW) VALUES ('"+ adminId+"', '"+adminPw+"')",
	function(err, result, fields) {
        
	if(err) 
	    console.log('query is not excuted. insert fail...\n' + err);
        else 
	    res.send('성공');
    });
});

const server = app.listen(port, () => {
	console.log('Express listening on port', port);
});
