from flask import Flask, request, send_file
import subprocess
import os

app = Flask(__name__)

@app.route('/generate', methods=['POST'])
def generate_pdf():
    xml_file = request.files['xml']
    xsl_name = request.form.get('xsl', 'stylesheets\fo_crosswalk_stylesheet.xsl')
    
    xml_path = '/tmp/input.xml'
    pdf_path = '/tmp/output.pdf'
    xsl_path = f'/opt/fop/stylesheets/{xsl_name}'

    xml_file.save(xml_path)

    
    try:
        subprocess.run([
            'fop.bat -c "conf/fop.xconf" -a',
            '-xml', xml_path,
            '-xsl', xsl_path,
            '-pdf', pdf_path
        ], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        
        return send_file(pdf_path, mimetype='application/pdf')
    
    except subprocess.CalledProcessError:
        return "PDF generation failed", 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)