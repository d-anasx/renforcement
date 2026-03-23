(()=>{


let obj1  = { a:1, b:{ x:1, y:2 } };

let obj2 = { b:{ y:99, z:3 }, c:{ f:99, e:3 } }



function override(obj1, obj2){
    for(i in obj1 ){
    for(j in obj2){
        if(typeof obj2[j] === 'object' && (j in obj1)){
            override(obj1[j], obj2[j])
        }
        else{
            obj1[j] = obj2[j]
        }
        
    }
    
}
}
override(obj1,obj2)

console.log(obj1);


})()