# draw a eDISH plot
# without plotly

library(haven)
library(dplyr)
library(ggplot2)
library(shiny)

# Read in the SAS data
adlb <- read_sas("C:\\edish\\adlb2.sas7bdat")

adlb <- adlb[(adlb$TRTSDT <= adlb$ADT & adlb$ADT <= adlb$TRTEDT+30),]

adlb1 <- adlb[(adlb$PARAMCD=="BILI"),]
adlb2 <- adlb[(adlb$PARAMCD=="ALT"),]

bili <- adlb1 %>% group_by(USUBJID) %>% top_n(1, AVAL)
alt <- adlb2 %>% group_by(USUBJID) %>% top_n(1, AVAL)

bili$y <- bili$AVAL/bili$ANRHI
alt$x <- alt$AVAL/alt$ANRHI

vs <- merge(bili, alt, by="USUBJID")
vs <- vs[c("y","x","USUBJID")]

ui <- fluidPage(
  
  titlePanel("eDISH Plot"),
    mainPanel(
      plotOutput(outputId = "ePlot")
      
    )
  )


server <- function(input, output) {
  output$ePlot <- renderPlot({
    
    h_line <- 2
    v_line <- 3
    
      myPlot <- ggplot(vs,  aes( x=x , y=y) ) +
        labs(title = "eDISH plot", 
             x = "Maximum ALT during the study (xULN)", y = "Maximum TBL during the study (XULN)") + 
        
        geom_point(size=2) +
        geom_hline(aes(yintercept=h_line)) +
        geom_text(aes(100,h_line,label='2XULN')) +
        geom_vline(aes(xintercept=v_line)) +
        geom_text(aes(v_line, 100, label='3XULN')) +
        
      scale_y_log10(limits=c(0.1,100)) +
      scale_x_log10(limits=c(0.1,100)) 
      
      print(myPlot) 
  })
  
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)
