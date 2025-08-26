import axios from 'axios';

//API call
export function generateReportfn({fileContent, fileName, reportType, setPDFUrl}){
    const formData = new FormData();
    const blob = new Blob([fileContent], { type: 'text/xml' });
    formData.append('xmlFile', blob, fileName);
    formData.append('option', reportType);

    return axios.post('http://localhost:5000/generate-pdf', formData,{
      responseType: 'blob',
    })
    .then((response) => {
      const url = window.URL.createObjectURL(new Blob([response.data], {type: 'application/pdf'}));
      const link = document.createElement('a');
      setPDFUrl(url);
      link.href = url;
    })
    .catch(err => {
      console.error('Error generating report: ', err);
      alert('Failed to generate report. Please check the server logs for details.');
    });
  };