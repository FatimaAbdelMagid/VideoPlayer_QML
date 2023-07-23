import QtQuick
import QtQuick.Dialogs
import QtMultimedia


Window{

    id: window

    width: 600
    height: 400
    visible:  true
    title: "Video Player"
    color: "#2f4f4f"

    property int fontSize: 20;



    //************************** "Choose a file" Button **************************
    Rectangle{
        id: chooseFileBtn
        height: 20 ; width: chooseFileBtnTxt.width
        anchors.top: window.top
        color: window.color

        Text{
            id: chooseFileBtnTxt
            text: "Choose a Video to open..."
            font.pixelSize: window.fontSize
            anchors.centerIn: parent
            color: "#d7fcfc"
            font.underline: true
        }

        MouseArea{
            anchors.fill: chooseFileBtn
            onClicked: {
                fileDialog.open()
            }
            onPressed: chooseFileBtnTxt.color ="blue"
            onReleased: chooseFileBtnTxt.color = "#e0ffff"
        }
    } // End of Rectangle >> chooseFileBtn



    //************************** File picker Dialog **************************
    FileDialog{
        id: fileDialog
        nameFilters: ["*.mp4 *.m4p *.avi"]

        onAccepted:{
            mediaPlayer.source = fileDialog.currentFile
            mediaPlayer.play()
        }
    }


    // ************************** Video Output **************************

    MediaPlayer{
        id:mediaPlayer
        audioOutput: audioOutput
        videoOutput: videoOutput
    }

    AudioOutput{
        id: audioOutput
    }

    VideoOutput{
        id: videoOutput
        anchors.fill: parent
        anchors.top: chooseFileBtn.bottom
        anchors.topMargin: window.fontSize + 5
        anchors.bottomMargin: window.fontSize + 35
    }




    //************************** play and pause buttons **************************
    Row{
        id: playPauseBtns
        anchors.top: videoOutput.bottom
        anchors.horizontalCenter: videoOutput.horizontalCenter

        spacing: 5

        // "Play" button
        Rectangle{

            id: playBtn; height: playBtntxt.height + 5; width: playBtntxt.width + 5; radius: 10; color: "#8fbc8f";

            Text{
                id:playBtntxt; text:" ▶ Play "; color: "white"; font.pixelSize: window.fontSize; anchors.centerIn: parent
            }

            MouseArea{
                anchors.fill: playBtn
                onClicked: {
                    mediaPlayer.play();
                }
                onPressed: playBtn.color ="#556b2f"
                onReleased: playBtn.color = "#8fbc8f"
            }

        }// End of "Play" Button


        // "Pause" button
        Rectangle{

            id: pauseBtn; height:pauseBtnTxt.height + 5; width: pauseBtnTxt.width + 5; radius:10; color: "#f08080";

            Text{
                id:pauseBtnTxt; text:" || Pause "; color: "white"; font.pixelSize: window.fontSize; anchors.centerIn: parent
            }

            MouseArea{
                anchors.fill: pauseBtn
                onClicked: {
                    mediaPlayer.pause();
                }
                onPressed: pauseBtn.color ="#cd5c5c"
                onReleased: pauseBtn.color = "#f08080"
            }

        } // End of "Pause" Button

    } // End of Row




    //************************** Video Progress Slider **************************

    Rectangle{
        id: progressSlider

        property real minimum: 0
        property real maximum: mediaPlayer.duration
        property real value: mediaPlayer.position


        height: 12; width: window.width
        color: "#d7fcfc"; radius: 5;

        anchors.top: playPauseBtns.bottom; anchors.margins: 5


        // Slider's Cursor to mark the point where the resizable rectangle is dragged to
        Rectangle{

            id: sliderCursor
            x: (progressSlider.value-progressSlider.minimum)/(progressSlider.maximum-progressSlider.minimum)*(progressSlider.width)
            anchors.verticalCenter: parent.verticalCenter

        } // End of Rectangle >> sliderCursor


        //Resizable rectangle of the slider marked by the Slider's cursor
        Repeater{
            model: 1
            delegate: Rectangle {
                x: !index? 0: sliderCursor.x
                width: !index? sliderCursor.x : progressSlider.width - sliderCursor.x;
                height: progressSlider.height
                color: "#7e8f8f"
                anchors.verticalCenter: parent.verticalCenter
                radius: 5
            }
        } // End of Repeater


        // Mouse Action of the Slider
        MouseArea{
            id: sliderMouse
            anchors.fill: parent
            drag.target: sliderCursor
            drag.axis: Drag.XAxis
            drag.minimumX: 0
            drag.maximumX: window.width

            onPositionChanged:  if(drag.active) mediaPlayer.position = mediaPlayer.duration * sliderCursor.x / progressSlider.width

        } // End of MouseArea >> SliderMouse


    }// End of Rectangle >> progressSlider



}//End of Window

// End of Code
