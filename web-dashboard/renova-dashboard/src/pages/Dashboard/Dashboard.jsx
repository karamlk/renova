import "./Dashboard.css";

//Components
import Sidebar from "../../components/Sidebar/Sidebar";
import Topbar from "../../components/Topbar/Topbar";
import Footer from "../../components/Footer/Footer";
//MUI Icons
import Avatar from '@mui/material/Avatar';
import AccountCircleIcon from '@mui/icons-material/AccountCircle';
import Loadingicon from "../../components/Loadingicon/Loadingicon";
import Grid from "@mui/material/Grid";
import {Outlet} from "react-router-dom";
//Context
import { LoadingContext } from "../../Context/Loadingcontext";
//Hooks
import{useContext,useState,useEffect} from "react";
//api
import { getProfileRequest } from "../../api/auth";

export default function Dashboard() {
  const {isloading}=useContext(LoadingContext);
  const [firstload,setfirstload]=useState(false);
  const[profile,setprofile]=useState({});
  //Requests
  async function loadProfile() {
        let response = await getProfileRequest();
        setprofile(response.data.data);
        }
  
  //init
  useEffect(()=>{
          async function init() {
            setfirstload(true);
            await new Promise(resolve => setTimeout(resolve, 1500));
            try{
              await loadProfile();
              }finally{
              setfirstload(false);
             }
 
          }
         init(); 
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
        {isloading && (<Loadingicon/>)}
          <Grid size={10} >
            <div className="body">
          <Grid container spacing={0}>
            {/*TopBar*/}
            <Grid size={12} >
              <Topbar first_name={profile?.profile?.first_name} last_name={profile?.profile?.last_name} image={profile?.profile?.full_image_url ? <Avatar  src={profile?.profile?.full_image_url} alt="img" sx={{ width: 35, height: 35 }} /> :<AccountCircleIcon fontSize="large" sx={{ color: '#f07c1f' }} />}/>
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
        
      
        
      </Grid>
      </div>
  )
  }
  
}
    