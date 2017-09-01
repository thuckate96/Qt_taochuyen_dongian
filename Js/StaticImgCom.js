var component
function createImage(listSource, coorImg,
                     waitTime, animateTime,
                     staticImgAngleSticker,
                     isAfter, hideImg,
                     commentStaticSticker){
    component = Qt.createComponent("../QML/DynamicStaticImgComp.qml")
    if(component.status === Component.Ready || component.status === Component.Error)
        finishCreation(listSource, coorImg,
                       waitTime, animateTime,
                       staticImgAngleSticker,
                       isAfter, hideImg,
                       commentStaticSticker)
    else
        component.statusChanged.connect(finishCreation)
}

function finishCreation(listSource, coorImg,
                        waitTime, animateTime,
                        staticImgAngleSticker,
                        isAfter, hideImg,
                        commentStaticSticker){
    if(component.status === Component.Ready){
        var image = component.createObject(page,
        {
          "listSrc": listSource,
          "coorImg": coorImg,
          "waitTime": waitTime,
          "animateTime": animateTime,
          "staticImgAngleSticker": staticImgAngleSticker,
          "isAfter": isAfter,
          "hideImg": hideImg,
          "commentStaticSticker": commentStaticSticker
        })
        if(image === null)
            console.log("error creating image")
    }else if(component.status === Component.Error)
        console.log("Error to load component: ", component.errorString())
}
