import React, { Component } from 'react';
import { BrowserRouter as Router, Route, Link } from 'react-router-dom';
import { makeStyles } from '@material-ui/core/styles';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';
import Button from '@material-ui/core/Button';
import logo from './photo/Logo.png';

const useStyles = makeStyles({
    root: {
        flexGrow: 1,
    },
    title: {
        flexGrow: 1,
    },
});

const MyAppBar = props => {
    const classes = useStyles();
    return (
        <div className={classes.root}>
            <AppBar position="static" style={{ background: '#01060A', height: 47 }}>
                <Toolbar>
                    <Typography variant="h6" className={classes.title} >
                        <img src={logo} alt ='logo' width='70' height='40'/>
                    </Typography>
                    <Button color="inherit" component={Link} to={{ pathname: '/' }}>HOME</Button>
                    <Button color="inherit" component={Link} to={{ pathname: '/admin' }}>ADMIN</Button>
                    <Button color="inherit" component={Link} to={{ pathname: '/userpage' }}>USER</Button>
                </Toolbar>
            </AppBar>
        </div>
    );
};

export default MyAppBar;