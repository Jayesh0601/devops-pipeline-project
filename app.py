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
                margin-top: 60px;
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
            .flow {
                max-width: 700px;
                margin: 40px auto;
                background: white;
                padding: 25px;
                border-radius: 8px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                text-align: left;
            }
            .flow h3 { text-align: center; color: #232f3e; }
            .flow-step {
                padding: 8px 0;
                border-bottom: 1px solid #eee;
                font-size: 15px;
            }
            .flow-step:last-child { border-bottom: none; }
            .arrow { color: #ff9900; font-weight: bold; margin-right: 8px; }
        </style>
    </head>
    <body>
        <h1>Production DevOps Pipeline</h1>
        <h2>Engineered by Jayesh Daud</h2>
        <div class="badge">Terraform</div>
        <div class="badge">AWS EKS</div>
        <div class="badge">Jenkins</div>
        <div class="badge">Docker</div>
        <div class="badge">Kubernetes</div>
        <div class="badge">ArgoCD</div>
        <div class="badge">Prometheus</div>
        <div class="badge">Grafana</div>
        <p>This application was built, scanned, and deployed completely automatically using GitOps.</p>

        <div class="flow">
            <h3>How this pipeline works</h3>
            <div class="flow-step"><span class="arrow">1.</span> Infrastructure (VPC, EKS cluster, Jenkins server) provisioned with <b>Terraform</b></div>
            <div class="flow-step"><span class="arrow">2.</span> Code pushed to GitHub triggers a <b>Jenkins</b> pipeline: tests, SonarQube scan, Docker build, Trivy security scan, push to DockerHub</div>
            <div class="flow-step"><span class="arrow">3.</span> Jenkins updates the Kubernetes manifest in Git with the new image tag</div>
            <div class="flow-step"><span class="arrow">4.</span> <b>ArgoCD</b>, running inside EKS, detects the Git change and auto-syncs the cluster to match</div>
            <div class="flow-step"><span class="arrow">5.</span> App runs on <b>AWS EKS</b>, exposed via a LoadBalancer</div>
            <div class="flow-step"><span class="arrow">6.</span> <b>Prometheus</b> and <b>Grafana</b> monitor the running app and cluster in real time</div>
        </div>
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