import * as React from "react";
import {Card, CardContent, CardHeader} from '@material-ui/core';
import { Resource} from "react-admin";
import Lout from './layout'
import {makeStyles} from "@material-ui/core/styles";


const WebFont = require('webfontloader');


WebFont.load({
    google: {
        families: ['Do Hyeon', 'Sansita Swashed']
    }
});

const useStyles = makeStyles({
    font: {
        marginLeft: 100,
        fontFamily: 'Sansita Swashed',
        textAlign: "center",
        fontSize: "40px",
        backgroundSize: "20%"
    },
});

export default function Userboard() {
    const classes = useStyles();
    return (
        <div>
            <Card>
                <CardHeader/>
                <h1 className={classes.font}>🎅Playdata🎅</h1>
                <CardContent>
                    <Resource name="member" list={Lout}/>
                </CardContent>
            </Card>
        </div>
    );


}
