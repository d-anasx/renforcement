function sontAnagrammes(word1, word2) {
  let anagrammes = true;

  if (word1.length !== word2.length) anagrammes = false;

  let arr = word1.split("");

  arr.forEach((item, index) => {
    if(arr.indexOf(item) !== index) anagrammes = false ;
  });

  arr.forEach((chr) => {
    if (!word2.includes(chr)) {
      anagrammes = false;
    }
  });

  return anagrammes ;
}

// sontAnagrammes("abaa", "cdba");


function grouperAnagrammes(arr) {
  let result = [];

  while (arr.length > 0) {
    let itemToCompare = arr[0];
    let group = [itemToCompare];

    arr.splice(0, 1);

    for (let i = 0; i < arr.length; i++) {
      if (sontAnagrammes(arr[i], itemToCompare)) {
        group.push(arr[i]);
        arr.splice(i, 1);
        i--; 
      }
    }

    result.push(group);
  }

  return result;
}

console.log(grouperAnagrammes(['ate','eat','tea','tan','nat','bat']))

