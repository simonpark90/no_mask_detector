// in src/App.js
import React, { Component } from 'react';
import { BrowserRouter as Router, Route, Link } from 'react-router-dom';
import userPage from './userPage';
import adminPage from './adminPage';

export const App = () => (
    <Router>
        <li>
            <Link to="/admin">admin</Link>
        </li>
        <li>
            <Link to="/userpage">userpage</Link>
        </li>

        <Route path="/admin" component={adminPage}/>
        <Route path="/userpage" component={userPage}/>
    </Router>
)
export default App;