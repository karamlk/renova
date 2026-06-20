import Sidebar from "./components/Sidebar/Sidebar";
import Topbar from "./components/Topbar/Topbar";
import MainContent from "./components/MainContent/MainContent";
import Footer from "./components/Footer/Footer";
import Grid from "@mui/material/Grid";
function App() {
  return (
    <div className="App">
      {/*AllPage*/}
      <Grid container spacing={0} style={{ height: "100vh" }}>
        {/*body*/}
        <Grid size={10}>
          <Grid container spacing={0}>
            {/*TopBar*/}
            <Grid size={12}>
              <Topbar />
            </Grid>
            {/*MainContent*/}
            <Grid size={12}>
              <MainContent />
            </Grid>
            {/*Footer*/}
            <Grid size={12}>
              <Footer />
            </Grid>
          </Grid>
        </Grid>
        {/*SideBar*/}
        <Grid size={2}>
          <Sidebar />
        </Grid>
      </Grid>
    </div>
  );
}

export default App;
