// frontend/src/App.js
import './App.css';
import ReportForm from './components/ReportForm';
import {generateReportfn} from './components/generateReport';
import React, { useState } from 'react';
import {Container, Typography} from '@mui/material';


function App() {
//set variables
const [reportType, setReportType] = useState('');
const [effectiveDate, setEffectiveDate] = useState('');
const [program, setProgram] = useState('');
const [crosswalkName, setCrosswalkName] = useState('');
const [fileName, setFileName] = useState('');
const [fileContent, setFileContent] = useState('');
const [showXmlEditor, setShowXmlEditor] = useState(false);
const [pdfUrl, setPDFUrl] = useState(null);
const [loading, setLoading] = useState(false);

//File upload
const handleFileChange = (event) => {
  const file = event.target.files[0];
  if (file) {
    setFileName(file.name);

    //Read file content
    const reader = new FileReader();
    reader.onload = (e) => {
      setFileContent(e.target.result);
    };
    reader.readAsText(file);
    }
  };

  const generateReport = () => {
    setLoading(true);
    generateReportfn({fileContent, fileName, reportType, setPDFUrl})
    .finally(() => setLoading(false));
  };


  return (
    <Container sx={{ mt: 4 }}>
        <div className="App-header" >
          <img src="images/JC_logo_RGB_withTag_TM.svg" alt="logo" style={{ height: 60 }} />
          <Typography variant="h6">GACPD Accessible Report Generator</Typography>
        </div>

        <ReportForm
          reportType={reportType}
          setReportType={setReportType}
          effectiveDate={effectiveDate}
          setEffectiveDate={setEffectiveDate}
          program={program}
          setProgram={setProgram}
          crosswalkName={crosswalkName}
          setCrosswalkName={setCrosswalkName}
          fileName={fileName}
          fileContent={fileContent}
          setFileContent={setFileContent}
          handleFileChange={handleFileChange}
          showXmlEditor={showXmlEditor}
          setShowXmlEditor={setShowXmlEditor}
          generateReport={generateReport}
          loading={loading}
          pdfUrl={pdfUrl}
        />

    </Container>
  );
}

export default App;