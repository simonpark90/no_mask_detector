import * as React from "react";

function Square(props) {
    return (
      <button className="square" onClick = {() => props.onClick()}>
        {props.value}
      </button>
    );
}

class Board extends React.Component {
  renderSquare(i) {
    return <Square value = {this.props.squares[i]} onClick={() => this.props.onClick(i)}/>;
  }

  render() {
    const rowPower = this.props.rowVal;
    const colPower = this.props.colVal;
    const squareNum = [];
    for(let i = 0; i < rowPower*colPower; i ++){
      if (i%colPower === 0){
        squareNum.push(i)
      }
    }
    const squares = squareNum.map((unitEl, idx) => {
      const rendedSq = []
      for(let i = 0 ; i < colPower; i++){
        rendedSq.push(this.renderSquare(unitEl+i))
      }
      return (
        <div className = "board-row">
          {rendedSq}
        </div>
      );
    })
    return (
      <div>
        {squares}
      </div>
    );
  }
}

class Game extends React.Component {
  constructor(props){
    super(props);
    this.state = {
      history : [{
        squares : Array(this.props.rowValue * this.props.colValue).fill("ㅁ")
      }],
      sortorBoolean : false,
      colPower : this.props.colValue,
      rowPower : this.props.rowValue,
      rowNumber : [],
      colNumber : [],
      stepNumber : 0,
      xIsNext : true,
    };
  }
  handleClick(i) {
    const rowNumber = this.state.rowNumber.slice(0,this.state.stepNumber);
    const colNumber = this.state.colNumber.slice(0,this.state.stepNumber);
    const history = this.state.history.slice(0,this.state.stepNumber + 1);
    const current = history[this.state.stepNumber];
    const squares = current.squares.slice();
    if (calculateWinner(squares)[0] || squares[i] === 'X' || squares[i] === 'O') {
      return;
    }
    squares[i] = this.state.xIsNext ? 'X' : 'O';
    this.setState({
      history: history.concat([{
        squares: squares,
      }]),
      rowNumber : rowNumber.concat([parseInt(i/this.state.colPower)]),
      colNumber : colNumber.concat([i%this.state.colPower]),
      stepNumber : history.length,
      xIsNext: !this.state.xIsNext,
    });
    // if (calculateWinner(squares)[1]){
    //   for(let i = 0; i < 3; i++){
    //     squares[calculateWinner[1][i]] = squares[calculateWinner[1][i]]
    //   }
    // }
  }
  jumpTo(step) {
    this.setState({
      stepNumber : step,
      xIsNext: (step %2) === 0
    });
  };
  toggler(){
    this.setState({
      sortorBoolean : !this.state.sortorBoolean
    })
  };
  render() {
    const rowPower = this.state.rowPower;
    const colPower = this.state.colPower;
    const history = this.state.history;
    const current = history[this.state.stepNumber];
    const winner = calculateWinner(current.squares)[0];
    let moves = history.map((step, move) => {
      const firstStr = 'Go to move #' + move + '('+this.state.colNumber[move-1]+','+this.state.rowNumber[move-1]+')';
      const startingStr = 'Go to game start';
      const desc = move ? firstStr : startingStr;
      return (
        <li key = {move}>
          <button onClick = {() => this.jumpTo(move)}>{desc}</button>
        </li>
      );
    });
    sortor(moves,this.state.sortorBoolean);
    let status;
    if (winner) {
      status = 'Winner: ' + winner;
    } else {
      status = 'Next player: ' + (this.state.xIsNext ? 'X' : 'O');
    }
    return (
      <div className="game">
        <div className="game-info">
          <div>
            <button onClick ={()=>this.toggler()}>{"Sort History"}</button>
          </div>
          <div>
            {status}
          </div>
          <ol>{moves}</ol>
        </div>
        <div className="game-board">
          <Board squares={current.squares} onClick={(i) => this.handleClick(i)} rowVal = {rowPower} colVal = {colPower}/>
        </div>
      </div>
    );
  }
}
function sortor(moves,sortorBoolean){
  moves.sort(function(a,b){
    return sortorBoolean ? b.key - a.key : a.key - b.key;
  })
  return moves
}
function calculateWinner(squares) {
  const lines = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];
  for (let i = 0; i < lines.length; i++) {
    const [a, b, c] = lines[i];
    if ((squares[a] && squares[a] === squares[b] && squares[a] === squares[c]) && (squares[a] !== "ㅁ")) {
      return [squares[a],[a, b, c]];
    }
  }
  return [null,null];
}
// class userPage extends React.Component {
//   render(){
//     return (
//       <Game rowValue = {3} colValue = {3}/>
//     )
//   }
// }
export const userPage = () => (
  <Game rowValue = {3} colValue = {3}/>
)

export default userPage;