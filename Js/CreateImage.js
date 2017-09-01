var component
function createImage(coorsImg, waitTime,
                     listSource, coorsMove,
                     animateTime, hideImg,
                     isAfter, angleSticker,
                     commentSticker){
    component = Qt.createComponent("../QML/AuImage.qml")
    if(component.status === Component.Ready || component.status === Component.Error)
        finishCreation(coorsImg,waitTime,
                       listSource, coorsMove,
                       animateTime, hideImg,
                       isAfter, angleSticker,
                       commentSticker)
    else
        component.statusChanged.connect(finishCreation)
}

function finishCreation(coorsImg, waitTime,
                        listSource, coorsMove,
                        animateTime, hideImg,
                        isAfter, angleSticker,
                        commentSticker){
    if(component.status === Component.Ready){
        var image = component.createObject(page,
        {"coorsImg": coorsImg,
          "waitTime": waitTime,
          "listSrc": listSource,
          "coorsMove": coorsMove,
          "animateTime": animateTime,
          "hideImg": hideImg,
          "isAfter": isAfter,
          "angleSticker": angleSticker,
          "commentSticker": commentSticker
        })
        if(image === null)
            console.log("error creating image")
    }else if(component.status === Component.Error)
        console.log("Error to load component: ", component.errorString())
}

function stopCom(){
    component = "";
}
