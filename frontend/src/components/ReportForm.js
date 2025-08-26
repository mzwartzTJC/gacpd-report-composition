// src/components/ReportForm.js
import {
  Button, Typography, FormControl, InputLabel, Select, MenuItem,
  Box, TextField, Collapse, CircularProgress
} from '@mui/material';

const ReportForm = ({
  reportType, setOption,
  fileName, fileContent, setFileContent,
  handleFileChange,
  showXmlEditor, setShowXmlEditor,
  generateReport, loading,
  pdfUrl
}) => (
  <>
    <Typography variant="body1" sx={{ mt: 2 }}>Select a report type:</Typography>

      <FormControl fullWidth sx={{ mt: 2 }}>
        <InputLabel id="dropdown-label">Choose an Option</InputLabel>
        <Select
          labelId="dropdown-label"
          value={reportType}
          label="Choose an Option"
          onChange={(e) => setOption(e.target.value)}
        >
          <MenuItem value="crosswalk">Crosswalk Report</MenuItem>
          <MenuItem value="NPG">NPG/NPSG Report</MenuItem>
        </Select>
      </FormControl>

      <Box display="flex" flexDirection="column" gap={2} sx={{ mt: 3 }}>
        <input 
          accept='.xml' 
          style={{ display: 'none' }} 
          id="upload-file" 
          type="file" 
          onChange={handleFileChange}
        />
      
        <label htmlFor="upload-file">
          <Button variant="contained" component="span">Upload File</Button>
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
          <Typography variant="h6">Report Preview:</Typography>
          <iframe
            src={pdfUrl}
            title="Report Preview"
            width="100%"
            height="600px"
            style={{ border: '1px solid #ccc' }}
          />
        <Button
          variant="outlined"
          sx={{ mt: 2 }}
          onClick={() => {
            const link = document.createElement('a');
            link.href = pdfUrl;
            link.setAttribute('download', `report-${reportType}.pdf`);
            document.body.appendChild(link);
            link.click();
            link.remove();
          }}
        >
        Download PDF
        </Button>
      </Box>
    )}
  </>
);

export default ReportForm;