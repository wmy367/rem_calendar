

class curveEvent{
    constructor(mjson){
        let attrs = ['date','title','desc','customClass','circle','id']
        for(let a of attrs){
            this[a] = mjson[a]
        }
    
        // if(this.circle==0){
        //     this.origin = true
        // }else{
        //     this.origin = false
        // }
        // this.customClass = 'lxj-highlight'
    }
}

var circleStep = [0,1,3,6,14];

function genCurveList(originEvent){
    let cList=[]
    let nd
    for(let cs of circleStep){
        let newObj = JSON.parse(JSON.stringify(originEvent)) 
        nd = new Date(originEvent.date)
        nd = nd.setDate(nd.getDate() + cs)
        nd = new Date(nd)

        newObj.date = nd.toLocaleDateString()
        newObj.startDate = originEvent.date
        newObj.circle = cs
        cList.push(newObj)
    }
    return cList
}

function curveCircleSteps(){
    return circleStep
}

export {
    curveEvent,
    genCurveList,
    curveCircleSteps
}