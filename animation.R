
#animation with gganimate
#gganimate: Create Animations with ggplot2
#http://www.sthda.com/english/articles/print/58-gganimate-create-animations-with-ggplot2/
# https://www.r-bloggers.com/gganimation-for-the-nation/
#https://github.com/thomasp85/gganimate

# gganimate extends the grammar of graphics as implemented by ggplot2 to include the description of animation. It does this by providing a range of new grammar classes that can be added to the plot object in order to customise how it should change with time.

    # transition_*() defines how the data should be spread out and how it relates to itself across time.
    # view_*() defines how the positional scales should change along the animation.
    # shadow_*() defines how data from other points in time should be presented in the given point in time.
    # enter_*()/exit_*() defines how new data should appear and how old data should disappear during the course of the animation.
    # ease_aes() defines how different aesthetics should be eased during transitions.


# if(!require(devtools)) install.packages("devtools")
# devtools::install_github('thomasp85/gganimate', force = TRUE)
#or 
# install.packages('gganimate')

# install.packages("gapminder")

# Inspect the data set:
  
  library(gapminder)

  head(gapminder)

# Load required package
library(gapminder)
library(ggplot2)
library(gganimate)
# install.packages("gifski")
library(gifski)

#An Example
ggplot(mtcars, aes(factor(cyl), mpg)) + 
  geom_boxplot() + 
  # Here comes the gganimate code
  transition_states(
    gear,
    transition_length = 2,
    state_length = 1
  ) +
  enter_fade() + 
  exit_shrink() +
  ease_aes('sine-in-out')

ggplot(gapminder, aes(gdpPercap, lifeExp, size = pop, colour = country)) +
  geom_point(alpha = 0.7, show.legend = FALSE) +
  scale_colour_manual(values = country_colors) +
  scale_size(range = c(2, 12)) +
  scale_x_log10() +
  facet_wrap(~continent) +
  # Here comes the gganimate specific bits
  labs(title = 'Year: {frame_time}', x = 'GDP per capita', y = 'life expectancy') +
  transition_time(year) +
  ease_aes('linear')


#To create video files you can e.g. use the ffmpeg_renderer():
p <- ggplot(airquality, aes(Day, Temp)) + 
  geom_line(size = 2, colour = 'steelblue') + 
  transition_states(Month, 4, 1) + 
  shadow_mark(size = 1, colour = 'grey')
animate(p, renderer = ffmpeg_renderer())


#If you wish to convert your old animations to the new API, the closest you get is probably with transition_manual, even though it is not completely substitutable:

# Old code
ggplot(mtcars) + 
  geom_boxplot(aes(factor(cyl), mpg, frame = gear))

# New code
ggplot(mtcars) + 
  geom_boxplot(aes(factor(cyl), mpg)) + 
  transition_manual(gear)
