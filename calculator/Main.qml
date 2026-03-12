import QtQuick
import QtQuick.Window
import QtQuick.Layouts

Window {
    id: root
    width: 360
    height: 520
    visible: true
    title: "Calculator"
    color: "#202020"

    property string currentInput: "0"
    property string expressionText: ""
    property real storedValue: 0
    property string currentOperator: ""
    property bool waitingForNextOperand: false

    property var buttons: [
        { label: "C",  type: "clear"     },
        { label: "⌫",  type: "backspace" },
        { label: "/",  type: "operator", color: "#ff9500" },
        { label: "*",  type: "operator", color: "#ff9500" },

        { label: "7",  type: "digit" },
        { label: "8",  type: "digit" },
        { label: "9",  type: "digit" },
        { label: "-",  type: "operator", color: "#ff9500" },

        { label: "4",  type: "digit" },
        { label: "5",  type: "digit" },
        { label: "6",  type: "digit" },
        { label: "+",  type: "operator", color: "#ff9500" },

        { label: "1",  type: "digit" },
        { label: "2",  type: "digit" },
        { label: "3",  type: "digit" },
        { label: "=",  type: "equals", color: "#4CAF50" },

        { label: "0",  type: "digit", span: 3 },
        { label: ".",  type: "dot" }
    ]

    function inputDigit(d) {
        if (waitingForNextOperand) {
            currentInput = d
            waitingForNextOperand = false
            return
        }

        if (currentInput === "0") {
            currentInput = d
        } else {
            currentInput += d
        }
    }

    function inputDot() {
        if (waitingForNextOperand) {
            currentInput = "0."
            waitingForNextOperand = false
            return
        }

        if (currentInput.indexOf(".") === -1) {
            currentInput += "."
        }
    }

    function clearAll() {
        currentInput = "0"
        expressionText = ""
        storedValue = 0
        currentOperator = ""
        waitingForNextOperand = false
    }

    function backspace() {
        if (waitingForNextOperand)
            return

        if (currentInput.length > 1) {
            currentInput = currentInput.slice(0, -1)
        } else {
            currentInput = "0"
        }
    }

    function setOperator(op) {
        let inputValue = Number(currentInput)

        if (currentOperator !== "" && !waitingForNextOperand) {
            performCalculation()
            inputValue = Number(currentInput)
        } else if (currentOperator === "") {
            storedValue = inputValue
        }

        currentOperator = op
        expressionText = storedValue + " " + currentOperator
        waitingForNextOperand = true
    }

    function performCalculation() {
        if (currentOperator === "")
            return

        let secondValue = Number(currentInput)
        let result = storedValue

        switch (currentOperator) {
        case "+":
            result = storedValue + secondValue
            break
        case "-":
            result = storedValue - secondValue
            break
        case "*":
            result = storedValue * secondValue
            break
        case "/":
            if (secondValue === 0) {
                currentInput = "Error"
                expressionText = ""
                storedValue = 0
                currentOperator = ""
                waitingForNextOperand = true
                return
            }
            result = storedValue / secondValue
            break
        }

        currentInput = String(result)
        expressionText = ""
        storedValue = result
        currentOperator = ""
        waitingForNextOperand = true
    }

    function handleButton(btn) {
        switch (btn.type) {
        case "digit":
            inputDigit(btn.label)
            break
        case "dot":
            inputDot()
            break
        case "operator":
            setOperator(btn.label)
            break
        case "equals":
            performCalculation()
            break
        case "clear":
            clearAll()
            break
        case "backspace":
            backspace()
            break
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        CalcScreen {
            Layout.fillWidth: true
            Layout.preferredHeight: parent.parent.height*0.2

            expressionText: root.expressionText
            displayText: root.currentInput
        }

        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 4
            rowSpacing: parent.parent.height*0.02
            columnSpacing: parent.parent.width*0.02

            Repeater {
                model: root.buttons

                delegate: Button {
                    required property var modelData

                    text: modelData.label
                    backgroundColor: modelData.color ? modelData.color : "#3a3a3a"

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.columnSpan: modelData.span ? modelData.span : 1

                    onClicked: root.handleButton(modelData)
                }
            }
        }
    }
}
