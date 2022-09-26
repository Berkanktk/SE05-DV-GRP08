# Practice 9
x1 = seq(from=1, to=101, by=1)
x2 = seq(from=1, to=101, by=1)
x3 = seq(from=1, to=101, by=1)

t = data.frame(a=x1, b=x1+x2, c=x1+x2+x3)

plot(t)

sd(x2)
sd(x3)
sd(x4)

# Practice 10
plot(t$a, type="l", ylim=range(t), lwd=3, col=rgb(1,0,0,0.3))
lines(t$b, type="s", lwd=2, col=rgb(0.3,0.4,0.3,0.9))
points(t$c, pch=20, cex=4, col=rgb(0,0,1,0.3))