<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:include href="tagged-pdf.xsl"/>
  <xsl:template match="processing-instruction()">
    <!-- remove input PIs -->
  </xsl:template>
  <xsl:template match="/Document|/DocumentFragment">
    <html>
      <head><link rel="stylesheet" href="iso32000.css"/></head>
      <body>
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="P[@role='Example' or @role='ExampleN+']">
    <pre>
      <xsl:apply-templates/>
    </pre>
  </xsl:template>
  <xsl:template match="P[@role='zzCoverT']">
    <title>
      <xsl:apply-templates/>
    </title>
    <h1>
      <xsl:apply-templates/>
    </h1>
  </xsl:template>
  <xsl:template match="P[@role='Heading 1']">
    <h2>
      <xsl:apply-templates/>
    </h2>
  </xsl:template>
  <xsl:template match="P[@role='Heading 2']">
    <h3>
      <xsl:apply-templates/>
    </h3>
  </xsl:template>
  <xsl:template match="P[@role='Heading 3']">
    <h4>
      <xsl:apply-templates/>
    </h4>
  </xsl:template>
  <xsl:template match="P[@role='Heading 4']">
    <h5>
      <xsl:apply-templates/>
    </h5>
  </xsl:template>
  <xsl:template match="P[@role='Heading 5' or @role='Heading 6']">
    <h6>
      <xsl:apply-templates/>
    </h6>
  </xsl:template>
</xsl:stylesheet>
