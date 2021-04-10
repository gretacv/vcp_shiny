# vcp_shiny
My first ever shiny app using data from [Figueiredo et al. 2020](https://www.thelancet.com/journals/lancet/article/PIIS0140-6736(20)31558-0/fulltext).
## Painpoint
### The plot was not using the available space in the `mainPanel`
`renderPlot(..., width = "auto", height = 600)` helped and `mainPanel(width = 10, ...)`
## Deployed
[https://gretacv.shinyapps.io/shiny_app/](https://gretacv.shinyapps.io/shiny_app/)
## Used tutorials
by Shiny, [github repo](https://github.com/rstudio-education/shiny.rstudio.com-tutorial)
by [Jakob37](https://github.com/Jakob37) [tutorial url](https://www.jakobwillforss.com/post/shiny-from-scratch-hands-on-tutorial/)
