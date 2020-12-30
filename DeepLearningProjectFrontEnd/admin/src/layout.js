import React from 'react';
import {makeStyles} from '@material-ui/core/styles';
import Grid from '@material-ui/core/Grid';
import Typography from '@material-ui/core/Typography';
import {Resource} from 'react-admin';
//import {UserList} from "./userTable";
import {UsersList} from "./punish";

const WebFont = require('webfontloader');

WebFont.load({
    google: {
        families: ['Do Hyeon', 'sans-serif']
    }
});


const useStyles = makeStyles((theme) => ({

        root: {
            marginLeft:  30,
            marginRight: 30,
            alignSelf: "center",
        },
        title: {
            fontFamily: 'Do Hyeon'

        }

    }));

export default function MultipleList() {
    const classes = useStyles();

    return (
        <div className={classes.root}>
            <Grid container>
                <Grid item xs={12}>
                    <Typography variant="h5" className={classes.title}>
                        최고 벌점자
                    </Typography>
                    <div>
                        <Resource name="member" list={UsersList} options={{ label: 'DUSASAE' }}/> {/* 벌점자 누적 상위 3명 */}
                    </div>
                </Grid>

                {/* <Grid item xs={4} md={3} className={classes.memo}>

                    <Typography variant="h5" className={classes.title}>
                        벌점 현황
                    </Typography>
                    <div className={classes.demo}>
                        <Resource name="member" list={UserList}/>
                    </div>
                </Grid> */}

                {/* <Grid item xs={4} md={3} className={classes.memo}>
                    <Typography variant="h5" className={classes.title}>
                        마스크 착용 의무화
                    </Typography>
                    <div className={classes.demo}>
                        <img
                            src="https://search.pstatic.net/common/?src=http%3A%2F%2Fimgnews.naver.net%2Fimage%2F5819%2F2020%2F11%2F13%2F0000010493_001_20201113113150217.jpg&type=sc960_832"
                            width="240px"/>
                    </div>
                </Grid> */}
            </Grid>
        </div>
    );
}
