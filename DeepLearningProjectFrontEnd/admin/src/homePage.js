import React from 'react';
import { makeStyles } from '@material-ui/core/styles';
import Parallax from "./cssStyle/Parallax.js"; //mainimage css
import GridContainer from "./cssStyle/GridContainer.js"; //grid container css
import GridItem from "./cssStyle/GridItem.js"; //grid css
import mainImg from './photo/homeimg.png'; //mainimage
import Footer from "./cssStyle/Footer.js"; //footer css


const componentsStyle = {
  container: {
    paddingRight: "15px",
    paddingLeft: "15px",
    marginRight: "auto",
    marginLeft: "auto",
    width: "100%",
    "@media (min-width: 576px)": {
      maxWidth: "540px"
    },
    "@media (min-width: 768px)": {
      maxWidth: "720px"
    },
    "@media (min-width: 992px)": {
      maxWidth: "960px"
    },
    "@media (min-width: 1200px)": {
      maxWidth: "1140px"
    }
  },
  brand: {
    color: "#FFFFFF",
    textAlign: "left"
  },
  title: {
    fontSize: "4.2rem",
    fontWeight: "600",
    display: "inline-block",
    position: "relative",
    color: "#FFFFFF"
  },
  subtitle: {
    fontSize: "1.313rem",
    maxWidth: "500px",
    margin: "10px 0 0",
    color: "#DD8F37"
  },
};

const useStyles = makeStyles(componentsStyle);

const Home = () => {
  const classes = useStyles();
  return (
    <div>
      <Parallax image={mainImg}>
        <div className={classes.container}>
          <GridContainer>
            <GridItem>
              <div className={classes.brand}>
                <h1 className={classes.title}>No Mask Detector with Deep Learning.</h1>
                <h3 className={classes.subtitle}>
                  Powered by DUSASAE.
                </h3>
              </div>
            </GridItem>
          </GridContainer>
        </div>
      </Parallax>
      <Footer />
    </div>
  );
};

export default Home;