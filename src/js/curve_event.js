

class curveEvent{
    constructor(mjson){
        let attrs = ['date','title','desc','customClass','circle','id','yesCurve','eventType']
        for(let a of attrs){
            this[a] = mjson[a]
        }
        this.show = true 
        this.origin = false
        this.links= []
        this.done = false
        // this.yesCurve = true
    
        // if(this.circle==0){
        //     this.origin = true
        // }else{
        //     this.origin = false
        // }
    }

    originDate(){
        var dateTime;
        dateTime = new Date(this.date)
        dateTime=dateTime.setDate(dateTime.getDate() - this.circle)
        dateTime=new Date(dateTime)
        return dateTime.toLocaleDateString()
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
        if(cs == 0){
            newObj.origin = true
        }
        if(originEvent.doneList){
            newObj.done = JSON.parse(originEvent.doneList)[cs]
        }
        if(originEvent.eventType != "curve"){
            break
        }
    }
    // cList[0].links = cList
    return cList
}

// function originDate(){
//     var dateTime;
//     dateTime = new Date(this.date)
//     dateTime=dateTime.setDate(dateTime.getDate() - this.circle)
//     dateTime=new Date(dateTime)
//     return dateTime.toLocaleDateString()
// }

function curveCircleSteps(){
    return circleStep
}

export {
    curveEvent,
    genCurveList,
    curveCircleSteps
}