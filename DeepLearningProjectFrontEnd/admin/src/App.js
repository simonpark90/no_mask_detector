// in src/App.js
import React, {Component} from 'react';
import {BrowserRouter as Router, Route, Link} from 'react-router-dom';
import UserPage from './userPage';
import adminPage from './adminPage';
import Home from './homePage';
import MyAppBar from './myappbar';


export default function App() {
    return (
        <Router>
            <div>
                <MyAppBar/>
                <Route exact path="/" component={Home}/>
                <Route path="/admin" component={adminPage}/>
                <Route path="/userpage" component={UserPage}/>
            </div>
        </Router>
    )
}