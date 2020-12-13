import React from 'react';
import logo from './logo.svg';
import './App.css';

class App extends React.Component {
	
	constructor(props) {
		super(props);
		this.state = {
			admins : null
		};
	}

	componentDidMount() {
		console.log('didMount');
		fetch('list')
			.then(res => res.json())
			.then(data => this.setState({admins:'data'}));
	}

	render() {
		return <div>{this.state.admins}</div>;
	}

}

export default App;
