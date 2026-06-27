import "./Dashboard.css";
import Sidebar from "../../components/Sidebar/Sidebar";
import Topbar from "../../components/Topbar/Topbar";
import Footer from "../../components/Footer/Footer";
import Loadingicon from "../../components/Loadingicon/Loadingicon";
import Grid from "@mui/material/Grid";
import {Outlet} from "react-router-dom";
import { LoadingContext } from "../../Context/Loadingcontext";
import{useContext,useState,useEffect} from "react";
import { useTranslation } from "react-i18next";
export default function Dashboard() {
  const {isloading}=useContext(LoadingContext);
  const [firstload,setfirstload]=useState(true);
  useEffect(() => {
    setTimeout(() => {
      setfirstload(false);
    },1000)
    
  },[]);

  if(firstload){
    return(<div className="loading-page">
        <Loadingicon/>
        </div>
        ) 
  }else{
      return (
    <div className="Dashboard">
     {/*AllPage*/}
      <Grid container spacing={0} sx={{ height: "100vh"}} >
        {/*SideBar*/}
        <Grid size={2}>
          <Sidebar />
        </Grid>
        {/*body*/}
        {isloading ? (<Loadingicon/>) : (
          
          <Grid size={10} >
            <div className="body">
          <Grid container spacing={0}>
            {/*TopBar*/}
            <Grid size={12} >
              <Topbar />
            </Grid>
            {/*MainContent*/}
            <Grid size={12}>
              <div className="main-content" >
          <Outlet/>
             </div>
            </Grid>
            {/*Footer*/}
            <Grid size={12}>
              <Footer />
            </Grid>
          </Grid>
          </div>
        </Grid>
        
      )}
        
      </Grid>
      </div>
  )
  }
  
}
    