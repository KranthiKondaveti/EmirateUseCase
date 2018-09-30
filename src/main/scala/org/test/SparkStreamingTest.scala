package org.test

import org.apache.kafka.common.serialization.StringDeserializer
import org.apache.spark.streaming.{Seconds, StreamingContext}
import org.apache.spark.streaming.kafka010.{ConsumerStrategies, KafkaUtils, LocationStrategies}
import org.apache.spark.{SparkConf, SparkContext}
import org.apache.spark.sql.{Row, _}
import org.apache.spark.sql.types.{DecimalType, DoubleType, LongType, StringType, StructField, StructType}
import org.apache.log4j.Logger
import org.apache.log4j.Level

import scala.collection.mutable.HashMap
import scala.collection.mutable
import org.apache.spark.sql.functions.regexp_replace

object SparkStreamingTest {

  def main(args: Array[String]): Unit = {
    println("started")

    val sparkConf = new SparkConf().setMaster("local[*]").setAppName("sparkstreamingproject")
    val ssc = new StreamingContext(sparkConf,Seconds(1))


    val kafkaParams = Map[String, Object](
      "bootstrap.servers" -> "localhost:9092,anotherhost:9092",
      "key.deserializer" -> classOf[StringDeserializer],
      "value.deserializer" -> classOf[StringDeserializer],
      "auto.offset.reset" -> "latest",
      "enable.auto.commit" -> (false: java.lang.Boolean)
    )

    /*diffrenet topics names*/
    val topics = Array("Carriers","OTP")

    val sstreams = KafkaUtils.createDirectStream[String,String](ssc,LocationStrategies.PreferConsistent,ConsumerStrategies.Subscribe[String,String](topics,kafkaParams))
    /*get the data from stream*/
    val data = sstreams.map(_.value())

    val datarowDF = data.map(line => Row.fromSeq(line))

    val schema = new StructType()
      .add(StructField("Year",StringType,true))
      .add(StructField("Month",StringType,true))
      .add(StructField("DayofMonth",StringType,true))
      .add(StructField("DayOfWeek",StringType,true))
      .add(StructField("DepTime",StringType,true))
      .add(StructField("CRSDepTime",StringType,true))
      .add(StructField("ArrTime",StringType,true))
      .add(StructField("CRSArrTime",StringType,true))
      .add(StructField("UniqueCarrier",StringType,true))
      .add(StructField("FlightNum",StringType,true))
      .add(StructField("TailNum",StringType,true))
      .add(StructField("ActualElapsedTime",StringType,true))
      .add(StructField("CRSElapsedTime",StringType,true))
      .add(StructField("AirTime",StringType,true))
      .add(StructField("ArrDelay",StringType,true))
      .add(StructField("DepDelay",StringType,true))
      .add(StructField("Origin",StringType,true))
      .add(StructField("Dest",StringType,true))
      .add(StructField("Distance",StringType,true))
      .add(StructField("TaxiIn",StringType,true))
      .add(StructField("TaxiOut",StringType,true))
      .add(StructField("Cancelled",StringType,true))
      .add(StructField("CancellationCode",StringType,true))
      .add(StructField("Diverted",StringType,true))
      .add(StructField("CarrierDelay",StringType,true))
      .add(StructField("WeatherDelay",StringType,true))
      .add(StructField("NASDelay",StringType,true))
      .add(StructField("SecurityDelay",StringType,true))
      .add(StructField("LateAircraftDelay",StringType,true))

    val flighdataFrame = spark.createDataFrame(rdd1,schema)

    val nullRemovedDF = flighdataFrame.columns.foldLeft(flighdataFrame) {
      (memoDF, colName) =>
        memoDF.withColumn(
          colName,
          regexp_replace(memoDF(colName),"NULL", "")
        )
    }

    val dataQualityDF = nullRemovedDF.columns.foldLeft(nullRemovedDF) {
      (memoDF1, colName) =>
        memoDF1.withColumn(
          colName,
          removeAllWhitespace(col(colName))
        )
    }

    val outputpath = ""
    dataQualityDF.write.option("header",true).option(SaveMode.append).save(outputpath)


    ssc.start()

    ssc.awaitTermination()
  }

}
