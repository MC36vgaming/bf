<!DOCTYPE html>
<html lang="zh-Hant">
<head>
    <meta charset="UTF-8">
    <title>線上抽獎系統</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 20px auto;
            padding: 20px;
        }
        .input-section {
            margin-bottom: 20px;
        }
        input, select, button {
            margin: 5px;
            padding: 8px;
        }
        #names-list {
            border: 1px solid #ccc;
            min-height: 100px;
            padding: 10px;
            margin: 10px 0;
        }
        #result {
            font-size: 24px;
            color: red;
            margin: 20px 0;
        }
        .highlight {
            background-color: yellow;
        }
    </style>
</head>
<body>
    <h1>線上抽獎系統</h1>
    
    <div class="input-section">
        <input type="text" id="nameInput" placeholder="輸入姓名">
        <button onclick="addName()">添加姓名</button>
    </div>

    <div id="names-list"></div>

    <div class="settings">
        <label>抽獎時間（秒）: </label>
        <input type="number" id="duration" value="5" min="1">
        
        <label>每次抽取數量: </label>
        <select id="drawCount">
            <option>1</option>
            <option>2</option>
            <option>3</option>
        </select>
    </div>

    <button onclick="startDraw()" id="drawButton">開始抽獎</button>
    <div id="result"></div>

    <script>
        let names = [];
        let isDrawing = false;

        function addName() {
            const nameInput = document.getElementById('nameInput');
            if (nameInput.value.trim()) {
                names.push(nameInput.value.trim());
                nameInput.value = '';
                updateNamesList();
            }
        }

        function updateNamesList() {
            const namesList = document.getElementById('names-list');
            namesList.innerHTML = names.map(name => 
                `<span class="name-item">${name}</span>`
            ).join('');
        }

        function startDraw() {
            if (isDrawing) return;
            
            const duration = document.getElementById('duration').value * 1000;
            const drawCount = parseInt(document.getElementById('drawCount').value);
            
            if (names.length < drawCount) {
                alert('參與人數不足！');
                return;
            }

            isDrawing = true;
            document.getElementById('drawButton').disabled = true;
            
            const startTime = Date.now();
            const resultDiv = document.getElementById('result');
            resultDiv.innerHTML = '抽獎進行中...';
            
            const drawInterval = setInterval(() => {
                const candidates = shuffleArray([...names]).slice(0, drawCount);
                resultDiv.innerHTML = candidates.join(', ');
            }, 50);

            setTimeout(() => {
                clearInterval(drawInterval);
                const winners = shuffleArray([...names]).slice(0, drawCount);
                resultDiv.innerHTML = `中獎者：${winners.join(', ')}`;
                
                // 移除中獎者（如需保留則刪除以下三行）
                names = names.filter(name => !winners.includes(name));
                updateNamesList();
                
                isDrawing = false;
                document.getElementById('drawButton').disabled = false;
            }, duration);
        }

        function shuffleArray(array) {
            return array.sort(() => Math.random() - 0.5);
        }
    </script>
</body>
</html>