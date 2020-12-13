import * as React from "react";
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';
const renderAll = () => {
  ReactDOM.render(
    <App />,
    document.getElementById('root')
  );
}

renderAll();
