import React from 'react';

class App extends React.Component {

	constructor(props) {
		super(props);
		this.state = {
			username:null
		};
	}

	render() {
		const {username} = this.state;
		return (
			<div className="App">
				<header className="App-header">
					{username ? `Hello ${username}` : 'Hello World'}
				</header>
			</div>
		);
	}

	componentDidMount() {
		fetch('/api')
			.then(res=>res.json())
			.then(data=>this.setState({username:data.username}));
	}
}

export default App;
