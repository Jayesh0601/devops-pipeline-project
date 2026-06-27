from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def home():
    return '''
    <html>
    <head>
        <title>DevOps Pipeline Project</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                text-align: center;
                margin-top: 100px;
                background-color: #f4f6f9;
            }
            h1 { color: #232f3e; }
            .badge {
                background-color: #ff9900;
                color: white;
                padding: 8px 16px;
                border-radius: 4px;
                display: inline-block;
                margin: 5px;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <h1>Production DevOps Pipeline</h1>
        <h2>Engineered by Jayesh Daud</h2>
        <div class="badge">Jenkins</div>
        <div class="badge">Docker</div>
        <div class="badge">Kubernetes</div>
        <div class="badge">ArgoCD</div>
        <div class="badge">Prometheus</div>
        <div class="badge">Grafana</div>
        <p>This application was built, scanned, and deployed completely automatically using GitOps.</p>
    </body>
    </html>
    '''

@app.route('/health')
def health():
    return jsonify({
        'status': 'healthy',
        'application': 'devops-pipeline-project',
        'version': '1.0.0'
    }), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

