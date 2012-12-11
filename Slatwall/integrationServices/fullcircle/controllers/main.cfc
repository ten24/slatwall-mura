component {
	
	public any function updateProducts() {
		var dataDAO = new Slatwall.integrationServices.fullcircle.com.DataDAO();
		dataDAO.updateProducts();
	}
	
}