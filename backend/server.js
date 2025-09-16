const express = require('express');
const cors = require('cors');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const { exec } = require('child_process');
const { v4: uuidv4 } = require('uuid');

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());

// Multer setup for XML file upload
const upload = multer({ dest: 'uploads/' });

app.post('/generate-pdf', upload.single('xmlFile'), (req, res) => {
  try {
    const reportType = req.body.option;

    if (!req.file || !reportType) {
      return res.status(400).send('Missing file or report type.');
    }

    const xslMap = {
      'crosswalk': 'fo_crosswalk_stylesheet.xsl',
      'CleanReport': 'fo_CleanReport_stylesheet.xsl',
      'prepub': 'fo_prepub_stylesheet.xsl',
      'NPG': 'fo_NPG_stylesheet.xsl'
    };

    const xslFile = xslMap[reportType];
    if (!xslFile) {
      fs.unlinkSync(req.file.path);
      return res.status(400).send('Invalid report type.');
    }
  
    const xmlPath = req.file.path;
    const xslPath = path.join(__dirname, 'stylesheets', xslFile);
    const outputPdf = path.join(__dirname, '..', `output-${uuidv4()}.pdf`);
    const fopJarPath = path.join(__dirname, 'fop-2.10', 'fop', 'build', 'fop-2.10.jar');
    const fopLib = path.join(__dirname, 'fop-2.10', 'fop', 'lib', '*');

    const fopCmd = `java -cp "${fopJarPath}:${fopLib}" org.apache.fop.cli.Main -a -xml "${xmlPath}" -xsl "${xslPath}" -pdf "${outputPdf}"`;

    exec(fopCmd, (error, stdout, stderr) => {
      
      console.log('FOP stdout:', stdout);
      console.error('FOP stderr:', stderr);

      if (error) {
        console.error(`FOP error: ${error}`);
        fs.unlinkSync(xmlPath); // Clean up uploaded XML
        return res.status(500).send('PDF generation failed. Check server logs for details.');
      }

      res.download(outputPdf, `${reportType}-accessible-report.pdf`, (err) => {
        fs.unlinkSync(xmlPath);
        fs.unlinkSync(outputPdf);
        if (err) {
          console.error(`Error downloading file: ${err}`);
        }
      });
    });
  } catch (err) {
    console.error(`Error processing file: ${err.message}`);
    return res.status(500).send('Internal server error.');
  }
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
