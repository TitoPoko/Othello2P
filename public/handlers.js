document.addEventListener('DOMContentLoaded', (event) => {
  console.log("DOM fully loaded and parsed");
});



function getGridSize() {
  return parseInt(document.getElementById('gridSize').value);
} 



function isSizeSet() {

  if (isNaN(getGridSize())) {
    alert('Please choose a grid size');
    return false;
  }
  return true;
}




function handleStartButtonClick() {

  const gridWidth = getGridSize();
  const player1Name = document.getElementById('player1Name').value.trim();
  const player2Name = document.getElementById('player2Name').value.trim();

  if (!isSizeSet()) {
    return;
  }

  if (!player1Name) {
    alert('Please enter player 1\'s name.');
    return;
  }

  if (!player2Name) {
    alert('Please enter player 2\'s name.');
    return;
  }


  fetch('/start', {

    method: 'POST', // Sending this data to '/start' POST
    headers: {
      'Content-Type': 'application/json' // Telling the server we're sending JSON data
    },
    body: JSON.stringify({
    grid_size: gridWidth,
    player_1_id: player1Name,
    player_2_id: player2Name
    })  //Sends gridWidth to the server(computer where app.rb is) and files it under grid_size
  })

  .then(response => response.json())  

  .then(data => {   // .then(data => block handles the data returned by the server.

    //console.log('Response from server:', data);  // Log the entire response
    console.log(
      'FROM: handleStartButtonClick... Game ID: ', data.game_id,
      'Grid width: ', data.grid_size,
      'P1: ', data.player_1_id,
      'P2: ', data.player_2_id
  );

    createGrid(data.grid_size);
  })
  .catch(error => {
    console.error('Error creating game in handleStartButtonClick:', error);
    alert('Something wrong in handleStartButtonClick. Game not created.');
  });
}



/*


let clicked = 999;
let gridCreated = false;
let size = -1;
let undoStack = [];
const directions = [[-1, -1], [0, -1], [1, -1], [-1, 0], [1, 0], [-1, 1], [0, 1], [1, 1]];
const players = ['black.jpeg', 'white.jpeg'];

*/