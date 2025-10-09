// src/components/ReportForm.js
import {
  Button, Typography, FormControl, InputLabel, Select, MenuItem,
  Box, TextField, Collapse, CircularProgress
} from '@mui/material';

const ReportForm = ({
  reportType, setReportType,
  effectiveDate, setEffectiveDate, 
  program, setProgram,
  crosswalkName, setCrosswalkName,
  fileName, fileContent, setFileContent,
  handleFileChange,
  showXmlEditor, setShowXmlEditor,
  generateReport, loading,
  pdfUrl
}) => (
  <>
  {/*
    <FormControl fullWidth sx={{ width: '35%', mt: 2 }}>
      <InputLabel id="effectice-date-label">Choose an Effective date</InputLabel>
      <Select
        labelId="effectice-date-label"
        value={effectiveDate}
        label="Choose an Effective date"
        onChange={(e) => setEffectiveDate(e.target.value)}
      >
        <MenuItem value="date5">01/18/2026</MenuItem>
        <MenuItem value="date4">01/01/2026</MenuItem>
        <MenuItem value="date3">08/01/2025</MenuItem>
        <MenuItem value="date2">07/01/2025</MenuItem>
        <MenuItem value="date1">01/01/2025</MenuItem>
      </Select>
    </FormControl>
  */}
    <Box sx={{display: 'flex', gap: 2, mb: 2}}>
      <FormControl fullWidth={false} sx={{ width: '33%', mt: 2 }}>
        <InputLabel id="report-type-label">Choose a Report Type</InputLabel>
        <Select
          labelId="report-type-label"
          value={reportType}
          label="Choose a Report Type"
          onChange={(e) => setReportType(e.target.value)}
        >
          <MenuItem value="crosswalk">Crosswalk Report</MenuItem>
          <MenuItem value="NPG">NPG/NPSG Report</MenuItem>
          <MenuItem value="CleanReport">Clean Report</MenuItem>
          <MenuItem value="prepub">Prepublication Report</MenuItem>
          <MenuItem value="SPG">SPG Report</MenuItem>
        </Select>
      </FormControl>
    </Box> {/*remove this line if other options below are added*/}
    {/*
      <FormControl fullWidth sx={{ mt: 2 }}>
        <InputLabel id="program-label">Choose an Program</InputLabel>
        <Select
          labelId="program-label"
          value={program}
          label="Choose a Report Type"
          onChange={(e) => setProgram(e.target.value)}
        >
          <MenuItem value="HAP">Hospital</MenuItem>
          <MenuItem value="CAH">Critical Access Hospital</MenuItem>
        </Select>
      </FormControl>
      {reportType === 'crosswalk' && (
        <FormControl fullWidth sx={{ mt: 2 }}>
          <InputLabel id="crosswalk-label">Choose an Crosswalk</InputLabel>
          <Select
            labelId="crosswalk-label"
            value={crosswalkName}
            label="Choose a Report Type"
            onChange={(e) => setCrosswalkName(e.target.value)}
          >
            <MenuItem value="HAP">CMS HAP to JC HAP</MenuItem>
            <MenuItem value="CAH">CMS CAH to JC CAH</MenuItem>
            <MenuItem value="DPU">CMS HAP to JC CAH</MenuItem>
          </Select>
        </FormControl>
      )}
    </Box>
    */}
      <Box display="flex" flexDirection="column" gap={2} sx={{ mt: 3 }}>
        <input 
          accept='.xml' 
          style={{ display: 'none' }} 
          id="upload-file" 
          type="file" 
          onChange={handleFileChange}
        />
      
        <label htmlFor="upload-file">
          <Button variant="contained" component="span">Load XML</Button>
        </label>
      
        {fileName && (
          <Typography variant="body1">Selected File: {fileName}</Typography>
        )}
      </Box>

      {fileContent && (
        <Box sx={{ mt: 2 }}>
          <Button variant="outlined" onClick={() => setShowXmlEditor(prev => !prev)}>
            {showXmlEditor ? 'Hide XML Content' : 'Show XML Content'}
          </Button>

          <Collapse in={showXmlEditor}> 
            <TextField
              label="Edit XML Content"
              multiline
              fullWidth
              minRows={10}
              maxRows={30}
              value={fileContent}
              onChange={(e) => setFileContent(e.target.value)}
              sx={{ mt: 2 }}
            />
          </Collapse>
        </Box>
      )}
  
      <Button variant='contained' sx={{mt:3}} onClick={generateReport} disabled={loading}>
          Generate Report
          {loading && <CircularProgress size={20} sx={{ml:2}}/>}
      </Button>

      {pdfUrl && (
        <Box sx={{ mt: 4 }}>
          <Button
          variant="outlined"
          aria-label="Download accessible PDF report"
          title="Download accessible PDF report"
          sx={{ mt: 2 }}
          onClick={() => {
            const link = document.createElement('a');
            link.href = pdfUrl;
            link.setAttribute('download', `report-${reportType}.pdf`);
            document.body.appendChild(link);
            link.click();
            link.remove();
          }}
          disabled={!pdfUrl}
          >
            Download PDF
          </Button>
          
          <Typography variant="h6">Report Preview:</Typography>
          <iframe
            src={pdfUrl}
            title="Report Preview"
            width="100%"
            height="600px"
            style={{ border: '1px solid #ccc' }}
          />
      </Box>
    )}
  </>
);

export default ReportForm;