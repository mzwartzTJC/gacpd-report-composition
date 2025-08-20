const { exec } = require('child_process');

function runFOP(xmlPath, xslPath, outputPath, callback) {
  const cmd = `java -jar ./fop/fop.jar -xml ${xmlPath} -xsl ${xslPath} -pdf ${outputPath}`;
  exec(cmd, callback);
}

module.exports = runFOP;
