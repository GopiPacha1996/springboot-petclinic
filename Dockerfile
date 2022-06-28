FROM openjdk:11
WORKDIR /app
COPY . .
RUN ./mvnw package
CMD java -jar target/*.jar
