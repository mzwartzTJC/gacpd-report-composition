// frontend/src/App.js
import React, { useEffect, useState } from 'react';
import './App.css';
import axios from 'axios';
import {Button, Container, Typography, 
  FormControl, InputLabel, Select, MenuItem,
  Box, TextField} from "@mui/material";


function App() {
//set variables
const [option, setOption] = useState('');
const [fileName, setFileName] = useState('');
const [fileContent, setFileContent] = useState('');
const [message, setMessage] = useState('');

//Dropdown menu
const handleChange = (event) => {
    setOption(event.target.value);
  };

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


//API call
  const fetchMessage = () => {
    axios.get('http://localhost:5000/api/message')
      .then(res => setMessage(res.data))
      .catch(err => console.error(err));
  };

  return (
    <Container sx={{ mt: 4 }}>
      <div className="App-header" >
        <img src="images/JC_logo_RGB_withTag_TM.svg" alt="logo" style={{ height: 60 }} />
        <Typography variant="h6">GACPD Accessible Report Generater</Typography>
      </div>

    <Typography variant="body1" sx={{ mt: 2 }}>Select a report type:</Typography>

    <FormControl fullWidth sx={{ mt: 2 }}>
      <InputLabel id="dropdown-label">Choose an Option</InputLabel>
      <Select
        labelId="dropdown-label"
        value={option}
        label="Choose an Option"
        onChange={handleChange}
      >
        <MenuItem value="crosswalk">Crosswalk Report</MenuItem>
        <MenuItem value="CleanReport">Clean Report</MenuItem>
        <MenuItem value="prepub">Prepublication/Field Review Report</MenuItem>
        <MenuItem value="NPG">NPG/NPSG Report</MenuItem>
      </Select>
    </FormControl>

    <br/>
    <br/>

    <Box display="flex" flexDirection="column" gap={2}>
      <input 
        accept='.xml' 
        style={{ display: 'none' }} 
        id="upload-file" 
        type="file" 
        onChange={handleFileChange}/>
      
      <label htmlFor="upload-file">
        <Button variant="contained" component="span">Upload File</Button>
      </label>
      
      {fileName && (
        <Typography variant="body1">Selected File: {fileName}</Typography>
      )}
    </Box>

    {fileContent && (
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
    )}
  
    <br/>
  
    <Button variant='contained' onClick={fetchMessage}>
        Generate Report
    </Button>

      {message && (
        <Typography variant="h6" sx={{ mt: 2 }}>
          {message}
        </Typography>
      )}
      <br/>
      <br/>

    </Container>
  );
}

export default App;